ActiveAdmin.register_page "Units" do
  page_action :update, method: :post do
    scope = AvailableUnit.where(name: params[:id])

    if params[:enabled] == "1"
      scope.create
      render text: "created", status: 200
    else
      scope.destroy_all
      render text: "destroyed", status: 200
    end
  end

  content title: "Units" do |a|
    @available_units = AvailableUnit.all.index_by &:name

    para "Any changes below are reflected immediately on the frontend."

    table class: "units index_table index" do
      thead do
        tr do
          th "Name", class: "name"
          th "Kind", class: "kind"
          th "Enabled", class: "enabled"
        end
      end

      tbody do
        Unit.definitions.sort_by do |name, unit|
          "#{unit.kind} #{unit.name}"
        end.each do |name, unit|
          tr do
            aliases = unit.aliases[1..-1].join(', ')
            td unit.display_name + (aliases.blank? ? "" : " (#{aliases})")
            td unit.kind.to_s.titleize

            td do
              form action: admin_units_update_path(id: name), method: :post do
                input(type: "hidden", name: "enabled", value: "0")
                params = @available_units.has_key?(name) ? { checked: "checked" } : {}
                input(params.merge(type: "checkbox", name: "enabled", value: "1"))
              end
            end
          end
        end
      end
    end
  end
end
