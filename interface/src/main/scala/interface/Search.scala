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
          if (r.size > 1) {
            children = Seq(new AllResultsButton (r.drop(1), t.name))
          }
        }
      )
    }
  }
}

class AllResultsButton(res: Result, tableName: String) extends Button {

  prefHeight = 15
  style = "-fx-font: 12 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
  text = "Show"

  onMouseClicked = e => {
    // FIXME other part where to not use head but primary key
    val att = Parameters.getPrimaryAttributes(tableName)
    val allAtt = Parameters.getAttributes(tableName)
    val sb = new StringBuilder
    sb ++= s"SELECT * FROM ${tableName} WHERE "
    for (name <- res) {
      if (att == Nil) {
        sb ++= s"${allAtt.head} = '${name.head}' OR "
      } else {
        val subSb = new StringBuilder
        subSb ++= "("
        for (p <- att) {
          subSb ++= s"${p} = '${name(allAtt indexOf p)}' AND "
        }
        sb ++= subSb.toString.dropRight(5)
        sb ++= ") OR "
      }
      
    }
    val query = sb.toString.dropRight(4)
    Center.children = Instance
    InstanceBean.setInstance(DatabaseLink.fetch(query))
    InstanceBean.previousWindow = Search
  }

}
