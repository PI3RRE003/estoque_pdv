import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "submitButton" ]

  connect() {
    // Escuta o teclado em toda a página
    document.addEventListener("keydown", this.handleKeydown.bind(this))
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    // F10 finaliza a venda
    if (event.key === "F10") {
      event.preventDefault() // Evita o comportamento padrão do Windows
      if (confirm("Deseja finalizar a venda agora? (F10)")) {
        this.submitButtonTarget.click()
      }
    }
  }
}