ActiveAdmin.register ExecutedSearch, as: "Searches" do
  index do
    column :user
    column :search_params do |search|
      search.search_params.map do |k, v|
        t("active_admin.executed_search.params.#{k}") + ": #{v}"
      end.join(", ")
    end
    column :results_count
  end
end
