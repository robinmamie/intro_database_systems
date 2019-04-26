package interface

import scalafx.scene.layout.Pane
import scalafx.scene.text.Text
import scalafx.geometry.Insets
import scalafx.scene.control.{Button, Label}
import scalafx.scene.layout.VBox
import scalafx.scene.paint.Color._
import scalafx.scene.text.Text

object Instance extends Pane {

  prefHeight = 900
  prefWidth = 1500 - Menu.menuWidth

  children = new VBox {
        padding = Insets(20)
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
          new Label {
            padding = Insets(40)
            text = "Lorem ipsum dolor sit amet blablabla I really would like to write a maximum of text here but I do not have any imagination please help me."
            wrapText = true
            prefWidth <== Instance.width
            style = "-fx-font-size: 16pt"
            textFill = White
          }
        )
      }
}

