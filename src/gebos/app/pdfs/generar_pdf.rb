class GenerarPdf < Prawn::Document

  def initialize

    super
    text "Estado de Cuenta debe imprimirse aqui"
  end

end