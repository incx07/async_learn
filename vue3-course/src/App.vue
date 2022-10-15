<template>
    <div class="app">
        <h1>My Application</h1>
        <div class="app__btns">
            <my-button
                @click="showDialog"
            >
                Add post
            </my-button>
            <my-select
                v-model="selectedSort"
                :options="sortOptions"
            >

            </my-select>           
        </div>
        <my-dialog v-model:show="dialogVisible">
            <post-form
                @create="createPost"       
            ></post-form>            
        </my-dialog>
        <post-list 
            :posts="posts"
            @remove="removePost"
            v-if="!isPostsLoadind"
        ></post-list>
        <div v-else> Posts are loading...</div>
    </div>
</template>


<script>
import PostForm from "./components/PostForm.vue";
import PostList from "./components/PostList.vue";
import MyDialog from "./components/UI/MyDialog.vue";
import axios from 'axios'
import MyButton from "./components/UI/MyButton.vue";
import MySelect from "./components/UI/MySelect.vue";


export default {
    components: {
    PostForm,
    PostList,
    MyDialog,
    MyButton,
    MySelect
},
    data() {
        return {
            posts: [],
            dialogVisible: false,
            isPostsLoadind: false,
            selectedSort: '',
            sortOptions: [
                {value: 'title', name: 'by title'},
                {value: 'body', name: 'by body'},
            ]
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
        },
        async fetchPosts() {
            this.isPostsLoadind = true;
            try {
                const responce = await axios.get('https://jsonplaceholder.typicode.com/posts?_limit=10');
                this.posts = responce.data;
            } catch (error) {
                alert('Error!')
            } finally {
                this.isPostsLoadind = false;
            }
        }
    },
    mounted() {
        this.fetchPosts();
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
.app__btns {
    margin: 15px 0;
    display: flex;
    justify-content: space-between;
}

</style>
