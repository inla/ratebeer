class AddStylesToBeers < ActiveRecord::Migration[5.2]
  def change
    Beer.all().each { |b| 
      b.style_id = Style.find_by(name: b.old_style).id
      b.save()
    }
  end
end
