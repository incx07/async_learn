import axios from 'axios';
import { ref, onMounted } from 'vue';


export function usePosts(limit) {
    const posts = ref([])
    const totalPages = ref(0)
    const isPostsLoadind = ref(true)
    const fetching = async () => {
        try {
            const responce = await axios.get('https://jsonplaceholder.typicode.com/posts', {
                params: {
                    _page: 1,
                    _limit: limit
                }
            });
            totalPages.value = Math.ceil(responce.headers['x-total-count'] / limit);
            posts.value = responce.data;
        } catch (error) {
            alert('Error!')
        } finally {
            isPostsLoadind.value = false;
        }
    }

    onMounted(fetching)

    return {
        posts, totalPages, isPostsLoadind
    }

}
