module GithubHelper
  def user_starred_repositories user
    user.starred_repositories.each_with_object([]) do |repository, array|
      array << link_to(repository.name, [user.name, repository.name].join('/'), target: '_blank')
    end.join ", "
  end
end