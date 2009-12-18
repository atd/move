module TasksHelper
  def responsible_options(task)
    children = task.owner.children.map{ |c| [ c.name, c.id ] }

    if task.owner.global?
      h = {}
      h[t('group.children.other')] = children if children.any?
      h[t('group.other')] = Group.roots.map{ |r| [ r.name, r.id ] }

      grouped_options_for_select h
    else
      children
    end
  end
end
