<template>
    <div>
        <h1>My Application [using Composition]</h1>
        <my-input
            v-focus
            v-model="searchQuery"
            placeholder="Search..."
        >
        </my-input>
        <div class="app__btns">
            <my-button
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
            ></post-form>            
        </my-dialog>
        <post-list 
            :posts="sortedAndSearchedPosts"
            v-if="!isPostsLoadind"
        ></post-list>
        <div v-else> Posts are loading...</div>
    </div>
</template>

<script>
import PostForm from "@/components/PostForm.vue";
import PostList from "@/components/PostList.vue";
import MyDialog from "@/components/UI/MyDialog.vue";
import MySelect from "@/components/UI/MySelect.vue";
import { usePosts } from '@/hooks/usePosts';
import useSortedPosts from '@/hooks/useSortedPosts';
import useSortedAndSearchedPosts from '@/hooks/useSortedAndSearchedPosts';


export default {
    components: {
    PostForm,
    PostList,
    MyDialog,
    MySelect,
    },
    data() {
        return {
            dialogVisible: false,
            sortOptions: [
                {value: 'title', name: 'by title'},
                {value: 'body', name: 'by body'},
                {value: 'id', name: 'by id'},
            ]
        }
    },
    setup(props) {

        const {posts, totalPages, isPostsLoadind} = usePosts(10);
        const {selectedSort, sortedPosts} = useSortedPosts(posts);
        const {searchQuery, sortedAndSearchedPosts} = useSortedAndSearchedPosts(sortedPosts)

        return {
            posts,
            totalPages,
            isPostsLoadind,
            selectedSort,
            sortedPosts,
            searchQuery, 
            sortedAndSearchedPosts
        }
    }
}
</script>


<style>
.app__btns {
    margin: 15px 0;
    display: flex;
    justify-content: space-between;
}
.observer {
    height: 30px;
    background: green;
}
</style>
