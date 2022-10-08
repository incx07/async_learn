<template>
    <div class="app">
        <post-form
            @create="createPost"       
        ></post-form>
        <post-list 
            :posts="posts"
        ></post-list>
    </div>
</template>


<script>
import PostForm from "./components/PostForm.vue";
import PostList from "./components/PostList.vue";


export default {
    components: {
    PostForm,
    PostList
},
    data() {
        return {
            posts: [
                {id: 1, title: 'Post 1', body: 'Long description 1'},
                {id: 2, title: 'Post 2', body: 'Long description 2'},
                {id: 3, title: 'Post 3', body: 'Long description 3'},
            ],

        }
    },
    methods: {
        createPost(post) {
            this.posts.push(post)
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

</style>
