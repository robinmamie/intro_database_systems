package tools

import scala.io.Source

object Parser {

  def getString(path: String, sep: String = "\n"): String = {
    val source = Source.fromFile(path)
    val string = source.getLines.mkString(sep)
    source.close
    string
  }

  def getStringList(path: String): List[String] = {
    var lines: List[String] = List()
    val source = Source.fromFile(path)
    for (line <- source.getLines) {
      lines = line :: lines
    }
    source.close
    lines.reverse
  }

}
