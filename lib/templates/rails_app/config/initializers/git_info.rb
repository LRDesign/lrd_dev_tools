if Rails.env.development? or Rails.env.staging?
  GIT_REVISION = `git --no-pager show --pretty=format:"%H" --quiet`[0..8]
  if GIT_REVISION =~ /fatal/
    GIT_REVISION = GIT_TAG = GIT_COMMIT_DATE = "N/A"
  else
    GIT_COMMIT_DATE = DateTime.parse(`git --no-pager show --pretty=format:"%ci" --quiet`)
    temp_tag = `git --no-pager describe 2>&1`
    if temp_tag =~ /fatal/
      GIT_TAG = "no tag"
    else
      GIT_TAG = temp_tag
    end
  end
end
