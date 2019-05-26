package interface

import scalafx.scene.layout.Pane
import scalafx.geometry.Insets
import scalafx.scene.control.{Button, ListView, ScrollPane, TextField}
import scalafx.scene.control.cell.CheckBoxListCell
import scalafx.scene.layout.{FlowPane, Pane, VBox, HBox}
import scalafx.scene.paint.Color._
import scalafx.scene.text.Text

import database._
import database.Parameters.Result
import interface.QueriesBean.Item
import interface.Instance._
import tools._

object Queries extends Pane {


  children = new VBox{
    padding = Insets(40)
    spacing = 20
    children = Seq(new HBox {
      padding = Insets(40)
      spacing = 20
      prefHeight = 700
      children = Seq(
        new ScrollPane {
        prefWidth = 330
        style = "-fx-background: black;"
        content = new VBox {
          spacing = 10
          children =
            QueriesBean.queries.map { q =>
              new Button {
                text = q.name
                prefWidth  = 300
                prefHeight = 30
                style = "-fx-font: 20 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
                onMouseClicked = e => {
                  val a = Parser.getString(q.file, " ")
                                .replace("#", QueriesBean.q1())
                                .replace("?", QueriesBean.q5())
                                .split(";")
                  for (i <- 0 until a.size - 1) DatabaseLink.execute(a(i))
                  InstanceBean.setInstance(DatabaseLink.fetch(a(a.size - 1)))
                }
              }
            }
          }
        }, new TableInst {
          prefWidth = 800
          }
        )
      }, new HBox {
        spacing = 40
        children = Seq(
          new Text {
            prefWidth = 800
            text = s"Query 1, number of bedrooms:"
            style = "-fx-font-size: 14pt"
            fill = White
          },
          new TextField {
            text <==> QueriesBean.q1
          }
        )
      }, new HBox {
        spacing = 40
        children = Seq(
          new Text {
            prefWidth = 800
            text = s"Query 5, host name:"
            style = "-fx-font-size: 14pt"
            fill = White
          },
          new TextField {
            text <==> QueriesBean.q5
          }
        )
      }
    )
  }

}
