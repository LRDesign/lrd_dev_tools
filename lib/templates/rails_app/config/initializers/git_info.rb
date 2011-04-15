if Rails.env.development? or Rails.env.staging?
  GIT_REVISION = `git show --pretty=format:"%H" --quiet`[0..8]
  if GIT_REVISION =~ /fatal/
    GIT_REVISION = GIT_TAG = GIT_COMMIT_DATE = "N/A"
  else
    GIT_COMMIT_DATE = DateTime.parse(`git show --pretty=format:"%ci" --quiet`)
    GIT_TAG = `git describe`
    GIT_TAG = "no tag" if GIT_TAG =~ /fatal/
  end
end