<template>
    
    <div>
        <h3>Users List</h3>
        <post-item 
            v-for="post in posts"
            :post="post"
            :key="post.id"
            @remove="$emit('remove', post)"
            >        
        </post-item>
    </div>

</template>

<script>
import PostItem from '@/components/PostItem';
export default {
    components: {
        PostItem
    },
    props: {
        posts: {
            type: Array,
            required: true
        }
    }
}
</script>

<style scoped>
    
</style>
