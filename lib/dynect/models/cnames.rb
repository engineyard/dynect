class Dynect::Client::Cnames < Cistern::Collection
  include Dynect::Collection

  model Dynect::Client::Cname

  model_root "cname"
  model_request :get_cname
end
