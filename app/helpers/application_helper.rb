module ApplicationHelper

	def btn_tooltip icon_class, btn_type, url, title_tooltip = nil, title = '', enabled = true
		link_to url, class: "btn #{btn_type} tooltip-btn", 'data-toggle': :tooltip, title: title_tooltip, enabled: enabled do
			capture_haml{"<i class='#{icon_class}'></i> #{title}"}
		end

	end

end
