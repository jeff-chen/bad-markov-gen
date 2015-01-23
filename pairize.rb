#END_OF_SENTENCE = "@@@@@@@@@@"
BEGIN_OF_SENTENCE = "@@@@@@@@@@"
require 'ruby-debug'
fun_sentence1 = "This is a sentence. Hi Vulpix and Tepig."
fun_sentence2 = "Vulpix and Tepig are cute omg. This pokemon is cute. Vulpix and Charmander."

vulpix = [fun_sentence1, fun_sentence2]

vulpix.each do |blah|
  blah = blah.downcase!
  #blah = blah.gsub!(/(?<=[\w+])[\.\?\!]/, ' .')
  blah = blah.insert(0,BEGIN_OF_SENTENCE + " ")
end

tokens = []

transition_pairs = {}

vulpix.each do |fun_sentence|
  (fun_sentence).split(" ").each_cons(2) do |a|
    tokens << a
  end
end

tokens.each do |k1, k2|
  k1 = k1.gsub(/[.?!]/,'')
  if transition_pairs[k1]
    if transition_pairs[k1][k2]
      transition_pairs[k1][k2] += 1
    else
      transition_pairs[k1][k2] = 1
    end
  else
    transition_pairs[k1] = {}
    transition_pairs[k1][k2] = 1
  end
end


#normalize probabilities
transition_pairs.each do |key, my_hash|
  sum = 0
  my_hash.each do |k,v|
    sum += v
  end
  my_hash.each do |word, count|
    my_hash[word] = Rational(count,sum)
  end
end


#now begin the sentence

sentence = ""

#puts "------"
50.times do |i|
  sampled_word = BEGIN_OF_SENTENCE
  sentence = ""
  until (sampled_word =~ /\w+[.?!]$/i)
    possible_words = transition_pairs[sampled_word]
    rand_digit = rand
    stuff = 0
    #debugger if sampled_word == "tepig"
    possible_words.each do |word, prob|
      if ((stuff < rand_digit)) && ((stuff + prob) > rand_digit)
        sampled_word = word
        sentence << sampled_word + " "
        stuff += prob
      else
        stuff += prob
      end
    end
  end
  puts sentence + "\n"
end



