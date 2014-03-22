<!DOCTYPE html>
<html>
<body bgcolor="#E6E6FA">
<head>
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Lang" content="en">
<title>Twitter Sentiment Analysis For Traffic Information</title>
</head>
<body>
<h1>Traffic data mining using sentiment analysis of twitter</h1>
<p>Enter your keyword below to perform Sentiment Analysis on Twitter Results: such as "congestion", "accident", "delay", "queue" and so on.</p>
<form method="GET">
    <label>Keyword: </label>
    <input type="text" name="target" /> 
    <input type="submit" value="Search"/>
</form>
<center>
  <button type="button">Save result to Database</button>
</center>
<?php

if(isset($_GET['target']) && $_GET['target']!='') {
   // Include the config.php file, which contains the API key and secret information.
    include_once(dirname(__FILE__).'/config.php');
    include_once(dirname(__FILE__).'/lib/TwitterSentimentAnalysis.php');

    $TwitterSentimentAnalysis = new TwitterSentimentAnalysis(DATUMBOX_API_KEY,TWITTER_CONSUMER_KEY,TWITTER_CONSUMER_SECRET,TWITTER_ACCESS_KEY,TWITTER_ACCESS_SECRET);

    //Search Tweets parameters as described at https://dev.twitter.com/docs/api/1.1/get/search/tweets
    $twitterSearchParams=array(
        'q'=>$_GET['target'],
        'lang'=>'en',
        'count'=>20,// here you can change the number of twitters to search and display.
    );
    $results=$TwitterSentimentAnalysis->sentimentAnalysis($twitterSearchParams);


    ?>
    <h1>Sentimant analysis results for "<?php echo $_GET['target']; ?>"</h1>
    <center>
    <table border="1">
        <tr>
            <td>Id</td>
            <td>User</td>
            <td>Twitter Post</td>
            <td>Twitter Link</td>
            <td>Sentiment Result</td>
            <td>Coordinates of the user</td>
        </tr>
        <?php
        foreach($results as $tweet) {
            
            $color=NULL;
            if($tweet['sentiment']=='positive') {
                $color='#00FF00';
            }
            else if($tweet['sentiment']=='negative') {
                $color='#FF0000';
            }
            else if($tweet['sentiment']=='neutral') {
                $color='#FFFFFF';
            }
           
            ?>
        
            <tr style="background:<?php echo $color; ?>;">
                <td><?php echo $tweet['id']; ?></td>
                <td><?php echo $tweet['user']; ?></td>
                <td><?php echo $tweet['text']; ?></td>
                <td><a href="<?php echo $tweet['url']; ?>" target="_blank">View</a></td>
                <td><?php echo $tweet['sentiment']; ?></td>
                <td>NULL</td>
            </tr>
            <?php
           
        }
        ?>
    </table>
    </center>
    <?php
}
?>

</body>
</html>
