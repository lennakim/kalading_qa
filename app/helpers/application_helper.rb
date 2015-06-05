module ApplicationHelper
  def link_to_with_modal(name = nil, options = nil, html_options = nil, &block)
    options, html_options = name, options if block_given?

    modal_id = html_options.delete(:modal_id)
    modal_class = html_options.delete(:modal_class) || ''

    link = if block_given?
             link_to(options,
                     {'data-toggle' => 'modal', 'data-target' => "##{modal_id}"}.merge(html_options),
                     &block)
           else
             link_to(name, options,
                     {'data-toggle' => 'modal', 'data-target' => "##{modal_id}"}.merge(html_options))
           end

    link + render('shared/modal_container', id: modal_id, modal_class: modal_class)
  end

  def current_user_info
    "角色：#{translate_roles(current_user.role_list).join('、')}，姓名：#{current_user.name}"
  end
end
