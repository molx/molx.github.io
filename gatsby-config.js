module.exports = {
    plugins: [
        {
            resolve: `gatsby-plugin-typography`,
            options: {
                pathToConfigModule: `src/utils/typography`,
            },
        },
        {
            resolve: `gatsby-source-filesystem`,
            options: {
                name: `data`,
                path: `${__dirname}/src/data/`,
            },
        },
        `gatsby-transformer-csv`,
        {
            resolve: `gatsby-plugin-google-analytics`,
            options: {
              trackingId: "UA-60942909-1",
            },
          },
    ],
}
