# Tampa Codernight 11/10/2016

https://www.meetup.com/CoderNight/events/234702675/

# Running:

Although the `.ruby_version` is 2.3.1, we really only need ruby 2.2.3+ for the `Etc.nprocessors` mention.

    ./challenge.rb épée

If you're using rbenv:

    rbenv exec ruby ./challenge.rb épée

# Challenge: Levenshtein Distance

Two words are friends if they have a Levenshtein distance of 1.
That is, you can add, remove, or substitute exactly one letter in word X to create word Y.

A word’s social network consists of all of its friends, plus all of their friends, and all of their friends’ friends, and so on.

Write a program to tell us how big the social network for the given word is, using our word list.

https://www.codeeval.com/open_challenges/58/ 
https://www.codeeval.com/public_sc/58/

# Sample input

https://dl.dropboxusercontent.com/u/6768419/input

# Pseudo Code

https://en.wikipedia.org/wiki/Levenshtein_distance

http://stackoverflow.com/questions/3183149/most-efficient-way-to-calculate-levenshtein-distance

http://blog.notdot.net/2010/07/Damn-Cool-Algorithms-Levenshtein-Automata

# GPU Approaches

http://cybcode.blogspot.com/2012/09/finally-holidays-and-some-gpu-code.html
https://raw.githubusercontent.com/cybercase/funproject/master/experiments/lev_distance.cu

http://williamedwardscoder.tumblr.com/post/24208897480/edit-distance-on-massive-strings

https://github.com/tensorflow/tensorflow/blob/master/tensorflow/g3doc/api_docs/python/functions_and_classes/shard2/tf.edit_distance.md

# tampa-codernight-20161110
