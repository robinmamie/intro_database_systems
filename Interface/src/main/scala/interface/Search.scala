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
              e => SearchBean.setResults(Lookup.allAttributes(SearchBean.searchText(), SearchBean.searchTables.toList.filter(i => i.selected()).map(i => i.name)))
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
  prefHeight = 500
  maxHeight = 10000

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
        new FlowPane {
          prefWidth = 800
          vgap = 5
          hgap = 3
          children = r.map {
            ls => new ResultButton(ls.head, t.name)
          }
        }
      )
    }
  }
}

class ResultButton(name: String, tableName: String) extends Button {

  prefHeight = 15
  style = "-fx-font: 12 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
  text = name

  onMouseClicked = e => {
    println(Parameters.attributeNames)
    //println(Parameters.primaryAttributes)
    InstanceBean.setInstance(DatabaseLink.fetch(s"SELECT * FROM ${tableName}"))
    InstanceBean.previousWindow = Search
    Center.children = Instance
  }

}
