module EasyPost
  module Stubs
    def stub_easypost
      [
        EasyPost::Address,
        EasyPost::Parcel,
        EasyPost::Shipment
      ].each do |ep_class|
        ep_class.stub(:create) do |opts|
          OpenStruct.new(opts)
        end
      end
    end
  end
end
