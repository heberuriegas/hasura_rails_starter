class ExampleDerivedAction < HasuraHandler::Action
  action_name :custom_update_users_by_pk

  def run
    @@update_user_mutation ||= HasuraClient.Client.parse %{
      mutation ($pk_columns: users_pk_columns_input!, $_set: users_set_input) {
        update_users_by_pk(pk_columns: $pk_columns, _set: $_set) {
          id
          username
          name
          email
          phone_number
        }
      }
    }

    pk_columns = @input['pk_columns']
    _set = @input['_set']

    result = HasuraClient.Client.query(@@update_user_mutation, 
      variables: {
        pk_columns: pk_columns,
        _set: _set
      }
    )

    if result&.data&.update_users_by_pk
      @output = result.data.update_users_by_pk.to_h
    else
      @error_message = result.errors.messages['data'].join(', ')
    end
  end
end
