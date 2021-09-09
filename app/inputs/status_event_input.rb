# frozen_string_literal: true

class StatusEventInput < SimpleForm::Inputs::CollectionSelectInput
  def collection
    object.aasm(:status).events(permitted: true).map do |event|
      [object.class.aasm(:status).human_event_name(event), event.name]
    end
  end

  def input(_wrapper_options)
    label_method = :first
    value_method = :second

    @builder.collection_select(
      attribute_name, collection, value_method, label_method,
      input_options, input_html_options
    )
  end
end
