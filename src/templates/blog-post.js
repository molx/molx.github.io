import React from "react"
import { graphql } from "gatsby"
import Layout from "../components/layout"
import * as postStyles from "./blog-post.module.css"

const blogPost = ({ data }) => {
    const post = data.markdownRemark
    return (
        <Layout>
            <div>
                <h1>{post.frontmatter.title}</h1>
                <div className={postStyles.postMetaData}>
                    <small>Publicado em: {post.frontmatter.date}</small>
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
                date(formatString: "DD/MM/YYYY")
                author
            }
        }
    }
`
