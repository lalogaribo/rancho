class DropSolicitudVuelos < ActiveRecord::Migration[5.1]
  def change
    drop_table :solicitud_vuelos
  end
end
