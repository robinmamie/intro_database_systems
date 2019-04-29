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


  children = new HBox {
    padding = Insets(40)
    spacing = 20
    prefHeight = 800
    children = Seq(
      new VBox {
        spacing = 10
        children =
          QueriesBean.queries.map { q =>
            new Button {
              text = q.name
              prefWidth  = 300
              prefHeight = 30
              style = "-fx-font: 20 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
              onMouseClicked = e => InstanceBean.setInstance(DatabaseLink.fetch(Parser.getString(q.file, " ")))
            }
          }
      },
      new TableInst {
        prefWidth = 800
      }
    )
  }

}
