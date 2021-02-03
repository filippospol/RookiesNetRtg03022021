library(nbastatR)
library(tidyverse)
library(gt)

plan(multiprocess)
teams_players_stats(seasons=2021, types='player',season_types="Regular Season",
                    tables='general',measures='Advanced',modes='PerGame',
                    is_rank=F,is_plus_minus=F,is_pace_adjusted=F,
                    players_experience = "Rookie")




df <- dataGeneralPlayers %>%
  select(namePlayer,slugTeam,gp,minutes,ortg,drtg,netrtg) %>% 
  filter(minutes>10, gp>=5) %>% 
  arrange(-netrtg) %>% 
  top_n(10)


df$head <-c("C:\\logos\\players\\reed.png","C:\\logos\\players\\pritchard.png",
            "C:\\logos\\players\\tillman.png","C:\\logos\\players\\campazzo.png",
            "C:\\logos\\players\\mcdaniels.png","C:\\logos\\players\\tate.png",
            "C:\\logos\\players\\bane.png","C:\\logos\\players\\vassell.png",
            "C:\\logos\\players\\stewart.png","C:\\logos\\players\\avdija.png")
df$logo <-c("C:\\logos\\nba\\phi.png","C:\\logos\\nba\\bos.png","C:\\logos\\nba\\mem.png",
            "C:\\logos\\nba\\den.png","C:\\logos\\nba\\min.png","C:\\logos\\nba\\hou.png",
            "C:\\logos\\nba\\mem.png","C:\\logos\\nba\\sas.png","C:\\logos\\nba\\det.png",
            "C:\\logos\\nba\\was.png")



mygt <- df %>% 
  select(head,namePlayer,logo,gp,minutes,ortg,drtg,netrtg) %>% 
  gt() %>% 
  cols_label(
    head="",namePlayer="Player",logo="Team",gp="Games",
    minutes="Minutes/Game",ortg="OffRtg",drtg="DefRtg",netrtg="NetRtg"
  ) %>% 
  tab_header(
    title = 
      html("<b>Top-10 Rookies in Net Rating</b>"),
    subtitle = html(
      "<em>Last update: 02/03/21. Rookies w/ at least 5 GP & 10 MPG</em>"
    )) %>%
  cols_align(
    align = "left",
    columns = vars(head)
  ) %>% 
  text_transform(
    locations = cells_body(vars(head)),
    fn = function(head) {
      lapply(head, local_image)
    }
  ) %>% 
  cols_align(
    align = "left",
    columns = vars(logo)
  ) %>% 
  text_transform(
    locations = cells_body(vars(logo)),
    fn = function(logo) {
      lapply(logo, local_image)
    }
  ) %>%
  tab_source_note(
    md("**Source:** NBA.com <br> **Table by:** Filippos Polyzos | @filippos_pol")
  )%>%
  tab_style(
    style=cell_text(font="Bahnschrift"),
    locations = list(cells_title(groups=c("title","subtitle")),
                     cells_body(columns=T,rows=T),
                     cells_column_labels(columns=vars(
                       head,namePlayer,logo,gp,minutes,ortg,drtg,netrtg))
    
  )) %>%
  tab_style(
    style = list(
      cell_fill(color = "#B7FFBD")
    ),
    locations = cells_body(
      rows = 5)) %>% 
  tab_options(
    heading.title.font.size = 28,
    heading.subtitle.font.size = 12,
    heading.align = "left",
    table.border.bottom.color =  "white",
    table.border.top.color = "white",
    column_labels.border.bottom.color = "black",
    column_labels.border.bottom.width = px(2),
    heading.border.bottom.color = "white",
    table_body.border.bottom.width = px(2),
    table_body.border.bottom.color = "black"
    
  )
mygt
gtsave(mygt,"p.png")
