module ApplicationHelper

	def render_haml(haml, locals = {})
		Haml::Engine.new(haml.strip_heredoc, format: :html5).render(self, locals)
	end

	def btn_tooltip icon_class, btn_type, url, title_tooltip = nil, title = '', enabled = true
		link_to url, class: "btn #{btn_type} tooltip-btn", 'data-toggle': :tooltip, title: title_tooltip, enabled: enabled do
			capture_haml{"<i class='#{icon_class}'></i> #{title}"}
		end
	end

	def alert_msg(content, type)
		render_haml <<-HAML, content: content, type: type
          .mt-2.alert.alert-dismissable{role: "alert", class: "alert-#{type}"}
            %button.close{"aria-label": :Close, "data-dismiss": :alert, type: :button}
              %span{"aria-hidden": true} ×
            = content.html_safe
		HAML
	end	

	def label_leveling(name)
		render_haml <<-HAML, period: name
			.m.3.badge.badge-success{style: 'margin-left: 20px'}
				%span.fa.fa-check
				Nivelación
				= period
		HAML
	end	
end
