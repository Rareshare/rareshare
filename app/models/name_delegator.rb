module NameDelegator
  def name_delegator(*attributes)
    attributes.each do |model|
      define_method "#{model}_name" do
        self.send(model).try(:name)
      end

      define_method "#{model}_name=" do |name|
        model_class = model.to_s.classify.constantize
        name = model_class.where(name: name).first || model_class.create(name: name)
        self.send "#{model}=", name
      end
    end
  end
end
