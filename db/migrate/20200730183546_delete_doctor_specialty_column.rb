class DeleteDoctorSpecialtyColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :doctors, :specialty, :string #suppression de la colonne specialty de la table doctors
  end
end
