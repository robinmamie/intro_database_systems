package interface

import scalafx.geometry.Insets
import scalafx.scene.control.{Button, ListView, ScrollPane, TextField}
import scalafx.scene.control.cell.CheckBoxListCell
import scalafx.scene.layout.{FlowPane, Pane, VBox, HBox}
import scalafx.scene.paint.Color._
import scalafx.scene.text.Text

import database._
import database.Parameters.Result
import interface.SearchBean.Item

object Insert extends Pane {

  prefHeight = 900
  prefWidth = 1500 - Menu.menuWidth

  children = new VBox {
    children = Seq(
      new HBox {
        padding = Insets(40)
        spacing = 20
        prefHeight = 800
        children = Seq(
          new VBox {
            spacing = 10
            children =
              Parameters.tableNames.map { t =>
                new Button {
                  text = t
                  prefWidth  = 300
                  prefHeight = 30
                  style = "-fx-font: 20 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
                  onMouseClicked = e => {
                    InsertBean.table <== text
                    InsertBean.setAttributes(Parameters.getAttributes(t))
                  }
                }
              }
          },
          new ScrollPane {
            prefWidth = 830
            content = InsDel
            style = "-fx-background: black;"
          }
        )
      }
    )
  }

}

object InsDel extends VBox {

  padding = Insets(40)
  spacing = 20
  prefHeight = 500
  maxHeight = 10000

  children = Seq()

  InsertBean.attributes.onChange { (b, c) =>
    SearchBean.searchTables.filter(i => i.selected()).toList zip SearchBean.results.toList
    children = new Text {
        prefWidth = 800
        text = s"Modification of table ${InsertBean.table()}"
        style = "-fx-font-size: 14pt"
        fill = White
      } :: InsertBean.attributes.map { a =>
        new HBox {
          spacing = 40
          children = Seq(
            new Text {
              prefWidth = 800
              text = s"${a.toLowerCase}"
              style = "-fx-font-size: 14pt"
              fill = White
            },
            new TextField {
              text <==> InsertBean.values(InsertBean.attributes.indexOf(a))
            }
          )
        }
      }.toList ++ List(
        new Button {
          text = "Insert"
          prefWidth  = 300
          prefHeight = 30
          style = "-fx-font: 20 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
          onMouseClicked =
            e => Modify.insert(InsertBean.table(), InsertBean.values.map(_()))
        },
        new Button {
          text = "Delete"
          prefWidth  = 300
          prefHeight = 30
          style = "-fx-font: 20 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
          onMouseClicked =
            e => Modify.delete(InsertBean.table(), InsertBean.values.map(_()))
        }
      )
  }
}
