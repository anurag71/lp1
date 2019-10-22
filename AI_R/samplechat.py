from nltk.chat.util import Chat,reflections

pairs =[
	[
		r"Hi|Hello",
		["Hi there, How are you?"]
	]

]

def chatbot():
	chat = Chat(pairs,reflections)
	chat.converse()

if __name__ == '__main__':
	chatbot()