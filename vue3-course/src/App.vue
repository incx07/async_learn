<template>
    <div class="app">
        <h1>My Application</h1>
        <my-button
            @click="showDialog"
            style="margin: 15px 0;"
        >
            Add post
        </my-button>
        <my-dialog v-model:show="dialogVisible">
            <post-form
                @create="createPost"       
            ></post-form>            
        </my-dialog>
        <post-list 
            :posts="posts"
            @remove="removePost"
        ></post-list>
    </div>
</template>


<script>
import PostForm from "./components/PostForm.vue";
import PostList from "./components/PostList.vue";
import MyDialog from "./components/UI/MyDialog.vue";


export default {
    components: {
    PostForm,
    PostList,
    MyDialog
},
    data() {
        return {
            posts: [
                {id: 1, title: 'Post 1', body: 'Long description 1'},
                {id: 2, title: 'Post 2', body: 'Long description 2'},
                {id: 3, title: 'Post 3', body: 'Long description 3'},
            ],
            dialogVisible: false,
        }
    },
    methods: {
        createPost(post) {
            this.posts.push(post);
            this.dialogVisible = false;
        },
        removePost(post) {
            this.posts = this.posts.filter(p => p.id !== post.id)
        },
        showDialog() {
            this.dialogVisible = true;
        }
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

</style>
