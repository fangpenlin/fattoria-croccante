module ApplicationHelper
  def collections_for_navigation(collections)
    Array.new.tap do |list_items|
      collections.each do |collection|
        content = link_to collection.name, collection_url(collection)

        # Recursively call this if the collection
        # has children
        unless collection.childs.empty?
          content << content_tag(:ul, collections_for_navigation(collection.childs))
        end

        list_items << content_tag(:li, content)
      end
    end.join.html_safe
  end
end
