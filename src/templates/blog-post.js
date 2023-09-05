import React from "react"
import { graphql } from "gatsby"
import Layout from "../components/layout"
import * as postStyles from "./blog-post.module.css"
import Seo from "../components/SEO"

const blogPost = ({ data }) => {
    const post = data.markdownRemark
    return (
        <Layout>
            <Seo title={post.frontmatter.title + " - Alan Mól"} />
            <div>
                <h1>{post.frontmatter.title}</h1>
                <div className={postStyles.postMetaData}>
                    <small>Published in: {post.frontmatter.date}</small>
                </div>
                <div dangerouslySetInnerHTML={{ __html: post.html }} />
            </div>
        </Layout>
    )
}
export default blogPost;
export const query = graphql`
    query($slug: String!) {
        markdownRemark(fields: { slug: { eq: $slug } }) {
            html
            frontmatter {
                slug
                title
                date(formatString: "YYYY-MM-DD")
                author
            }
        }
    }
`
