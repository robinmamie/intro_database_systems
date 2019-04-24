package interface

import scalafx.geometry.Insets
import scalafx.scene.control.{Button, ListView, ScrollPane, TextField}
import scalafx.scene.control.cell.CheckBoxListCell
import scalafx.scene.layout.{Pane, VBox, HBox}
import scalafx.scene.paint.Color._
import scalafx.scene.text.Text

import database._
import database.Parameters.Result
import interface.SearchBean.Item

object Search extends Pane {

  prefHeight = 900
  prefWidth = 1500 - Menu.menuWidth

  children = new VBox {
    children = Seq(
      new HBox {
        padding = Insets(40)
        spacing = 20
        prefHeight = 100
        children = Seq(
          new TextField {
            prefWidth = 400
            promptText = "Type here to search..."
            text <==> SearchBean.searchText
          },
          new Button {
            text = "Search"
            onMouseClicked =
              e => SearchBean.setResults(Lookup.allAttributes(SearchBean.searchText(), SearchBean.searchTables.toList.map(i => i.name)))
          }
        )
      },
      new HBox {
        padding = Insets(40)
        spacing = 20
        prefHeight = 800
        children = Seq(
          new ListView[Item] {
            prefWidth = 300
            items = SearchBean.searchTables
            cellFactory = CheckBoxListCell.forListView(_.selected)
            style = "-fx-cell-size: 20; -fx-text-fill: white; -fx-control-inner-background: black; -fx-background-insets: 0;"
          },
          new ScrollPane {
            prefWidth = 830
            content = ShowResults
            style = "-fx-background: black;"
          }
        )
      }
    )
  }

}

object ShowResults extends VBox {

  padding = Insets(40)
  spacing = 20
  prefHeight = 800

  children = Seq()

  SearchBean.results.onChange { (b, c) =>
    val res: List[(Item, Result)] = SearchBean.searchTables.toList zip SearchBean.results.toList
    children = res flatMap { case (t, r) =>
      Seq(
        new Text {
          prefWidth = 800
          text = s"${r.size - 1} results for table ${t.name}"
          style = "-fx-font-size: 14pt"
          fill = White
        },
        new Text {
          prefWidth = 800
          text = "This is a test"
          style = "-fx-font-size: 12pt"
          fill = White
        }
      )
    }
  }

}
