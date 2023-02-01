# frozen_string_literal: true

class Hotel
  attr_accessor :id, :nombre, :precio, :puntaje, :link, :provincia
  attr_reader :categories
  def initialize(id, nombre, precio, puntaje, link, provincia)
    @id = id
    @nombre = nombre
    @precio = precio
    @puntaje = puntaje
    @link = link
    @provincia = provincia
  end

  def guardar(other_csv = './Data/x.csv')
    CSV.open(other_csv, 'a') do |csv|
      csv << [@id, @nombre, @precio, @puntaje, @link, @provincia]
    end
  end
end
