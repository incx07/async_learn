<template>
    <div class="app">
        <form @submit.prevent>
            <h4>Create a post</h4>
            <input 
                v-bind:value="title" 
                @input="title = $event.target.value" 
                class="input" 
                type="text" 
                placeholder="Title"
            >
            <input 
                v-bind:value="body" 
                @input="body = $event.target.value" 
                class="input" 
                type="text" 
                placeholder="Description"
            >
            <button 
                class="btn" 
                @click="createPost">Create
            </button>
        </form>

        <div class="post" v-for="post in posts">
            <div><strong>Title:</strong> {{ post.title }}</div>
            <div><strong>Description:</strong> {{ post.body }}</div>
        </div>
    </div>
</template>


<script>
export default {
    data() {
        return {
            posts: [
                {id: 1, title: 'Post 1', body: 'Long description 1'},
                {id: 2, title: 'Post 2', body: 'Long description 2'},
                {id: 3, title: 'Post 3', body: 'Long description 3'},
            ],
            title: '',
            body: '',

        }
    },
    methods: {
        createPost() {
            const newPost = {
                id: Date.now(),
                title: this.title,
                body: this.body,
            }
            this.posts.push(newPost);
            this.title = '';
            this.body = '';
        },
    }
}

</script>


<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}
.app {
    padding: 20px;
}
.post {
    padding: 15px;
    border: 2px solid teal;
    margin-top: 15px;
}
form {
    display: flex;
    flex-direction: column;
}
.input {
    width: 100%;
    border: 1px solid teal;
    padding: 10px 15px;
    margin-top: 15px;
}
.btn {
    margin-top: 15px;
    align-self: flex-end;
    padding: 10px 15px;
    background: none;
    color: teal;
    border: 1px solid teal;
}
</style>
