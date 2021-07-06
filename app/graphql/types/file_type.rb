module Types
  class FileType < GraphQL::Schema::Object
    field :url, String, null: false
  end

  class BigInt < GraphQL::Types::BigInt
    graphql_name "bigint"
  end

  class FilesAttributes < Types::BaseInputObject
    description "Attributes for query files for a specific model"
    argument :record_id, Types::BigInt, "Model instance id", required: true
    argument :record_type, String, "Model class name", required: true
  end
  
end