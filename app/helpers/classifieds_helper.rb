module ClassifiedsHelper

 def delete_link(classified, user)
  link_to 'delete',
	  community_classified_path(classified.community, classified),
	  method: :delete,
	  data: { confirm: 'Are you sure?' } if classified.owned_by?(user)
 end

 def edit_link(classified, user)
   link_to 'edit', edit_community_classified_path(classified.community, classified) if classified.owned_by?(user)
 end

 def list_all_classifieds_link(community)
  link_to 'list all community classifieds', community_classifieds_path(community)
 end

end
