class SetDefaultToolCondition < ActiveRecord::Migration
  def change
    Tool.update_all condition: Tool::Condition::DEFAULT
  end
end
