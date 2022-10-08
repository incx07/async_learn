<template>
    
    <div>
        <h3>Users List</h3>
        <PostItem 
            v-for="post in posts"
            :post="post"
            >        
        </PostItem>
    </div>

</template>

<script>
import PostItem from '@/components/PostItem';
export default {
    components: {PostItem},
    props: {
        posts: {
            type: Array,
            required: true
        }
    }
}


</script>

<style scoped>
.post {
    padding: 15px;
    border: 2px solid teal;
    margin-top: 15px;
}
    
</style>
