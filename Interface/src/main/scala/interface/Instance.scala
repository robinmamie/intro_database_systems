package interface

import scalafx.beans.property.StringProperty
import scalafx.scene.layout.Pane
import scalafx.scene.text.Text
import scalafx.geometry.Insets
import scalafx.scene.control.{Button, Label}
import scalafx.scene.control.TableColumn._
import scalafx.scene.control.{TableCell, TableColumn, TableView}
import scalafx.scene.layout.VBox
import scalafx.scene.paint.Color._
import scalafx.scene.text.Text

object Instance extends Pane {

  prefHeight = 900
  prefWidth = 1500 - Menu.menuWidth

  children = new VBox {
        padding = Insets(20)
        spacing = 10
        children = Seq(
          new Button {
            prefWidth  = 50
            prefHeight = 50
            style = "-fx-font: 42 arial; -fx-background-color: grey; -fx-border: none; -fx-text-fill:white;"
            text = "X"
            onMouseClicked = e => {
              InstanceBean.previousWindow = Search
              Center.children = InstanceBean.previousWindow
            }
          },
          TableInst
        )
      }
}

object TableInst extends TableView[List[StringProperty]] {

  prefWidth = 1100
  prefHeight = 700
  val data = InstanceBean.instance.onChange{
    (buf, _) =>
      if (!buf.isEmpty) {
        println("Setting information")
        items = buf.tail
        columns.clear()
        for (i <- 0 until buf(0).size) {
          columns += new TableColumn[List[StringProperty], String] {
            text <==> buf.head(i)
            cellValueFactory = { _.value(i) }
          }
        }
      }
  }
}

