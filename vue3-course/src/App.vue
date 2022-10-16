<template>
    <div class="app">
        <h1>My Application</h1>
        <my-input
            v-model="searchQuery"
            placeholder="Search..."
        >
        </my-input>
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
            :posts="sortedAndSearchedPosts"
            @remove="removePost"
            v-if="!isPostsLoadind"
        ></post-list>
        <div v-else> Posts are loading...</div>
        <div class="page__wrapper">
            <div 
                v-for="pageNumber in totalPages" 
                :key="pageNumber"
                class="page"
                :class="{
                    'current-page': page === pageNumber
                }"
                @click="changePage(pageNumber)"
                >
                {{ pageNumber }}
            </div>
        </div>
    </div>
</template>


<script>
import axios from 'axios';
import PostForm from "./components/PostForm.vue";
import PostList from "./components/PostList.vue";
import MyDialog from "./components/UI/MyDialog.vue";
import MySelect from "./components/UI/MySelect.vue";


export default {
    components: {
    PostForm,
    PostList,
    MyDialog,
    MySelect,
},
    data() {
        return {
            posts: [],
            dialogVisible: false,
            isPostsLoadind: false,
            selectedSort: '',
            searchQuery: '',
            page: 1,
            limit: 10,
            totalPages: 0,
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
        changePage(pageNumber) {
            this.page = pageNumber;
        },
        async fetchPosts() {
            this.isPostsLoadind = true;
            try {
                const responce = await axios.get('https://jsonplaceholder.typicode.com/posts', {
                    params: {
                        _page: this.page,
                        _limit: this.limit
                    }
                });
                this.totalPages = Math.ceil(responce.headers['x-total-count'] / this.limit);
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
    },
    computed: {
        sortedPosts() {
            return [...this.posts].sort((post1, post2) => {
                return post1[this.selectedSort]?.localeCompare(post2[this.selectedSort])
            })
        },
        sortedAndSearchedPosts() {
            return this.sortedPosts.filter(post => post.title.toLowerCase().includes(this.searchQuery.toLowerCase()))
        }
    },
    watch: {
        page() {
            this.fetchPosts()
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
.app__btns {
    margin: 15px 0;
    display: flex;
    justify-content: space-between;
}
.page__wrapper {
    display: flex;
    margin-top: 15px;
}
.page {
    border: 1px solid black;
    padding: 10px;
}
.current-page {
    border: 2px solid teal;
}
</style>
