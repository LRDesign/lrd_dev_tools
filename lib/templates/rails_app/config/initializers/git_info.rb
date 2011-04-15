if Rails.env.development? or Rails.env.staging?
  GIT_REVISION = `git show --pretty=format:"%H" --quiet`[0..8]
  GIT_COMMIT_DATE = DateTime.parse(`git show --pretty=format:"%ci" --quiet`)
  GIT_TAG = `git describe`
  GIT_TAG = nil if GIT_TAG =~ /fatal/
end