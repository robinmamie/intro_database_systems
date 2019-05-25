package interface

import scalafx.geometry.Insets
import scalafx.scene.control.Button
import scalafx.scene.layout.VBox
import scalafx.scene.paint.Color._
import scalafx.scene.text.Text

object Menu extends VBox {

  val HOME = "HOME"
  val SEARCH = "SEARCH"
  val QUERIES = "QUERIES"
  val INSERT = "INSERT\nDELETE"

  val menuWidth = 300

  prefWidth = menuWidth
  padding = Insets(10)

  children = Seq(
    /*new Text {
      prefWidth = menuWidth
      prefHeight = 30
      text = "Airbnb"
      style = "-fx-font-size: 18pt; -fx-font-style: italic"
      fill = Grey
    },
    new Text {
      prefWidth = menuWidth
      prefHeight = 30
      text = "by group 11"
      style = "-fx-font-size: 14pt; -fx-font-style: italic"
      fill = Grey
    },*/
    new MenuButton(HOME),
    new MenuButton(SEARCH),
    new MenuButton(QUERIES),
    new MenuButton(INSERT))

  object Current {
    var value: MenuButton = _
  }

  class MenuButton(name: String) extends Button {


    val css = "-fx-font: 36 arial; -fx-background-color: black; -fx-border: none;"
    val white = "-fx-text-fill: white;"
    val grey = "-fx-text-fill: grey;"

    prefWidth = menuWidth
    prefHeight = 150
    text = name

    val correspPane = name match {
        case HOME    => Welcome
        case SEARCH  => Search
        case QUERIES => Queries
        case INSERT  => Insert
      }

    if (correspPane == Welcome) {
      style = css + white
      Current.value = this
    }
    else {
      style = css + grey
    }

    onMouseClicked = e => {
      InstanceBean.instance.clear()
      Center.children = correspPane
      Current.value.style = css + grey
      style = css + white
      Current.value = this
    }
  }

}
