# Dependencies
brew install phantomjs
brew install chromedriver
brew install geckodriver
xcode-select --install

# Ruby
brew install rbenv ruby-build
echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
source ~/.bash_profile
rbenv install 2.3.3
rbenv global 2.3.3

# Execution Context
gem install bundler
bundle install
