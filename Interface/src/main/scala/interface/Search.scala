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
    val res: List[(Item, Result)] = SearchBean.searchTables.filter(i => i.selected()).toList zip SearchBean.results.toList
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
          // FIXME use something else than head => PrimaryKey
          if (r.size > 1) {
            children = new AllResultsButton (r.drop(1), t.name) :: r.drop(1).map {
              ls => new ResultButton(ls.head, t.name)
            }
          }
        }
      )
    }
  }
}

class AllResultsButton(res: Result, tableName: String) extends Button {

  prefHeight = 15
  style = "-fx-font: 12 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
  text = "ALL"

  onMouseClicked = e => {
    // FIXME other part where to not use head but primary key
    val att = Parameters.getAttributes(tableName).head
    val sb = new StringBuilder
    sb ++= s"SELECT * FROM ${tableName} WHERE "
    for (name <- res) {
      sb ++= s" ${att} = '${name.head}' OR"
    }
    val query = sb.toString.dropRight(3)
    Center.children = Instance
    InstanceBean.setInstance(DatabaseLink.fetch(query))
    InstanceBean.previousWindow = Search
  }

}

class ResultButton(name: String, tableName: String) extends Button {

  prefHeight = 15
  style = "-fx-font: 12 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
  text = name

  onMouseClicked = e => {
    // FIXME other part where to not use head but primary key
    val att = Parameters.getAttributes(tableName).head
    Center.children = Instance
    InstanceBean.setInstance(DatabaseLink.fetch(s"SELECT * FROM ${tableName} WHERE ${att} = '${name}'"))
    InstanceBean.previousWindow = Search
  }

}
